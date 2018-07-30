---
layout: post
title: Asynchronous testing in Elixir with Mox
crosspost_to_medium: true
tags: [programming, elixir, code, testing, mocks]
---

Testing in Elixir is pretty neat. You can easily test anything that was written, you have
instruments like ExUnit or ESpec, you can [practice TDD](https://github.com/lpil/mix-test.watch) and
more and more. Functional programming paradigm helps you a lot to make you testing even simpler
by forcing you to use pure, small functions that will be pleasant to test. Concurrency of Elixir
allows you to run all your tests asynchronously and blazingly fast.

However, there can be caveats.

## Mocks problem

If you're programming a big project then I suppose that you will be using third-party services anyway.
Imagine that you are sending SMS through you favorite provider services. This can code look like this:

```elixir
SmsProvider.send_sms(from, to, "message")
```

In this case you are using external provider API in order to send SMS. The HTTP request will go from
your application to the destination and it will trigger SMS delivery.

Now we need to test this situation. This will be our very first approach:

```elixir
assert {:ok, %Message{}} = SmsProvider.send_sms(from, to, "message")
```

As you can see it will behave like it would be in production. Your SMS with the nasty fake test message
will be delivered to non-existent users with absent phone numbers. Sad!

The most popular solution is mocking. You're supposing that call of `send_sms` function with expected
arguments will return expected result:

```elixir
mock(SmsProvider, :send_sms, fn _, _, _ -> {:ok, %Message{status: :sent}} end)
assert {:ok, %Message{status: :sent}} = SmsProvider.send_sms(from, to, "message")
```

This will work, at least for the one test. The problem is simple enough - it's not the best solution
for asynchronous tests. We have mocked SmsProvider so it will be overrided in every next asynchronous
test:

```elixir
use MyApp.DataCase, async: true

# ...

assert {:error, :wrong_phone_number} = SmsProvider.send_sms(wrong_number, to, "message")
```

This test will fail because `send_sms` call was already mocked in another before.
The entire mocking approach is not suitable for concurrent testing, so we need to take yet another one.

## Asynchronous testing

Instead of mocking we can try to call function that will override `sms_send/3`. Let's create a `TestProvider` module
with the next content:

```elixir
defmodule TestProvider do
  def send_sms(from, to, message) do
    {:ok, %Message{status: :sent, from: from, to: to, text: message}}
  end
end
```

From now we can try to use this module as an adapter in our `SmsProvider` module. It will use default
adapter in development, production environments and will use `TestProvider` in testing:

```elixir
# config/test.exs
config :my_app, SmsProvider, adapter: TestProvider

# config/config.exs
config :my_app, SmsProvider, adapter: SmsApiService

# sms_provider.ex
defmodule SmsProvider do
  @adapter Application.fetch_env(:my_app, :sms_provider, :adapter)

  defdelegate send_sms(from, to, message), to: @adapter
end
```

Let's go straight to the test:

```elixir
assert {:ok, %Message{}} = SmsProvider.send_sms(from, to, "message") # true
```

Now it should works even in concurrent tests. Your SMS will not be delivered to the real nor fake users,
you money will be saved and your tests will not suffer more.

## Using Mox

However, there still a room for improvement.

## Conclusion

If you're definitely insterested in concurrent testing, you can try to read [excellent article from Jose Valim](http://blog.plataformatec.com.br/2015/10/mocks-and-explicit-contracts/) and dive in into [Mox documentation](https://hexdocs.pm/mox/Mox.html).

Happy hacking, everyone!

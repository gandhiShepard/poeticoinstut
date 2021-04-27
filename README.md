# Poeticoins

To start your Phoenix server:

- Install dependencies with `mix deps.get`
- Install Node.js dependencies with `npm install` inside the `assets` directory
- Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Notes

- This is a fantastic tutorial

## Coinbase

```elixir
ticker: %{
  "best_ask" => "56135.22",
  "best_bid" => "56135.20",
  "high_24h" => "57111",
  "last_size" => "0.0051",
  "low_24h" => "54334",
  "open_24h" => "55829.2",
  "price" => "56135.2",
  "product_id" => "BTC-USD",
  "sequence" => 24011598392,
  "side" => "sell",
  "time" => "2021-04-21T16:24:15.188090Z",
  "trade_id" => 158890901,
  "type" => "ticker",
  "volume_24h" => "13805.11457010",
  "volume_30d" => "446560.84002373"
}
```

## BitStamp

```elixir
unhandled message: %{
  "channel" => "live_trades_btcusd",
  "data" => %{
    "amount" => 0.00308,
    "amount_str" => "0.00308000",
    "buy_order_id" => 1352493277192192,
    "id" => 166193509,
    "microtimestamp" => "1619033528659000",
    "price" => 55583.75,
    "price_str" => "55583.75",
    "sell_order_id" => 1352493248823297,
    "timestamp" => "1619033528",
    "type" => 0
  },
  "event" => "trade"
}

```

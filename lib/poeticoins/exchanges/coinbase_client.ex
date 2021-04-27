defmodule Poeticoins.Exchanges.CoinbaseClient do
  # use GenServer

  alias Poeticoins.{Trade, Product, Exchanges}
  alias Poeticoins.Exchanges.Client
  require Client
  # import Client, only: [validate_required: 2]

  Client.defclient(
    exchange_name: "coinbase",
    host: 'ws-feed.pro.coinbase.com',
    port: 443,
    currency_pairs: ["BTC-USD", "ETH-USD", "LTC-USD", "BTC-EUR", "ETH-EUR", "LTC-EUR"]
  )

  # @behaviour Client
  # @exchange_name "coinbase"

  # @impl true
  # def exchange_name, do: "coinbase"
  # this is being handled by client.ex now

  # def start_link(currency_pairs, options \\ []) do
  #   GenServer.start_link(__MODULE__, currency_pairs, options)
  # end

  # def init(currency_pairs) do
  #   state = %{
  #     currency_pairs: currency_pairs,
  #     conn: nil
  #   }

  #   {:ok, state, {:continue, :connect}}
  # end

  # def handle_continue(:connect, state) do
  #   {:noreply, connect(state)}
  # end

  # @impl true
  # def server_host, do: 'ws-feed.pro.coinbase.com'

  # @impl true
  # def server_port, do: 443

  # def connect(state) do
  #   {:ok, conn} = :gun.open(server_host(), server_port(), %{protocols: [:http]})
  #   %{state | conn: conn}
  # end

  # def handle_info({:gun_up, conn, :http}, %{conn: conn} = state) do
  #   :gun.ws_upgrade(conn, "/")
  #   {:noreply, state}
  # end

  # def handle_info({:gun_upgrade, conn, _ref, ["websocket"], _headers}, %{conn: conn} = state) do
  #   subscribe(state)
  #   {:noreply, state}
  # end

  # def handle_info({:gun_ws, conn, _ref, {:text, msg} = _frame}, %{conn: conn} = state) do
  #   handle_ws_message(Jason.decode!(msg), state)
  # end

  @impl true
  def subscription_frames(currency_pairs) do
    msg =
      %{
        "type" => "subscribe",
        "product_ids" => currency_pairs,
        "channels" => ["ticker"]
      }
      |> Jason.encode!()

    [{:text, msg}]
  end

  @impl true
  def handle_ws_message(%{"type" => "ticker"} = msg, state) do
    # IO.inspect(msg, label: "ticker")
    # _trade = message_to_trade(msg) |> IO.inspect(label: "trade")
    {:ok, trade} = message_to_trade(msg)
    Exchanges.broadcast(trade)
    # topic = "#{trade.product.exchange_name}:#{trade.product.currency_pair}"
    # topic = to_string(trade.product)
    # Phoenix.PubSub.broadcast(Poeticoins.PubSub, topic, {:new_trade, trade})
    Poeticoins.Exchanges
    {:noreply, state}
  end

  @impl true
  def handle_ws_message(msg, state) do
    IO.inspect(msg, label: "unhandled message")
    {:noreply, state}
  end

  # defp subscribe(state) do
  #   # subscription frames
  #   subscription_frames(state.currency_pairs)
  #   |> Enum.each(fn frame -> :gun.ws_send(state.conn, frame) end)

  #   # send frames
  # end

  @spec message_to_trade(map()) :: {:ok, Trade.t()} | {:error, any()}
  def message_to_trade(msg) do
    with :ok <- validate_required(msg, ["product_id", "time", "price", "last_size"]),
         {:ok, traded_at, _} <- DateTime.from_iso8601(msg["time"]) do
      currency_pair = msg["product_id"]
      # product = Product.new(@exchange_name, currency_pair)
      # price = msg["price"]
      # volume = msg["last_size"]
      # traded_at = traded_at

      {:ok,
       Trade.new(
         product: Product.new(exchange_name(), currency_pair),
         price: msg["price"],
         volume: msg["last_size"],
         traded_at: traded_at
       )}
    else
      {:error, _reason} = error -> error
    end
  end

  # No longer needed
  #
  # defp datetime_from_string(time_string) do
  #   {:ok, dt, _} = DateTime.from_iso8601(time_string)
  #   dt
  # end

  #   @spec validate_required(map(), [String.t()]) :: :ok | {:error, {String.t(), :required}}
  #   def validate_required(msg, keys) do
  #     required_key = Enum.find(keys, fn k -> is_nil(msg[k]) end)

  #     if is_nil(required_key),
  #       do: :ok,
  #       else: {:error, {required_key, :required}}
  #   end
end

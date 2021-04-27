defmodule Poeticoins.Trade do
  alias Poeticoins.Product

  @type t :: %__MODULE__{
          product: Product.t(),
          traded_at: DateTime.t(),
          price: String.t(),
          volume: String.t()
        }

  defstruct [
    :product,
    :traded_at,
    :price,
    :volume
  ]

  # lets create a constuctor that take a keyword list
  @spec new(Keyword.t()) :: t()
  def new(fields) do
    # %__MODULE__{
    #   product: Keyword.fetch!(fields, :product)
    # }

    # struct! will rasie an error at run time, so don't put any unspecified keys in this struct
    struct!(__MODULE__, fields)
  end
end

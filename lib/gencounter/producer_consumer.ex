defmodule Concurrency.GenCounter.ProducerConsumer do
  use GenStage
  require Integer

  alias Concurrency.GenCounter

  # ProducerConsumer => middleware

  def start_link(_pid) do
    # :state => merely a fillter
    GenStage.start_link(__MODULE__, :state, name: __MODULE__)
  end

  def init(state) do
    {:producer_consumer, state, subscribe_to: [GenCounter.Producer]}
  end

  def handle_events(events, _from, state) do
    # count till infinity and just show the even nums
    numbers = events |> Enum.filter(&Integer.is_even/1)

    {:noreply, numbers, state}
  end
end

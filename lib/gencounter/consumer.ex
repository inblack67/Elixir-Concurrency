defmodule Concurrency.GenCounter.Consumer do
  use GenStage

  alias Concurrency.GenCounter

  def start_link(_pid) do
    GenStage.start_link(__MODULE__, :state)
  end

  def init(state) do
    {:consumer, state, subscribe_to: [GenCounter.ProducerConsumer]}
  end

  def handle_events(events, _from, state) do
    for event <- events do
      IO.inspect({self(), event, state})
    end

    {:noreply, [], state}
  end
end

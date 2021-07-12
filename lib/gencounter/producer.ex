defmodule Concurrency.GenCounter.Producer do
  use GenStage

  def start_link(_pid) do
    GenStage.start_link(__MODULE__, 0, name: __MODULE__)
  end

  # :producer => declaring this module as a producer
  def init(counter), do: {:producer, counter}

  # consumer will make the demand
  def handle_demand(demand, state) do
    # fairly large numbers
    events = Enum.to_list(state..(state + demand - 1))
    {:noreply, events, state + demand}
  end
end

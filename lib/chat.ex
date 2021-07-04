defmodule Concurrency.Chat do
  use GenServer

  # client side
  def start_link do
    # start a process with the attributes of the current module
    GenServer.start_link(__MODULE__, [])
  end

  def get_messages(pid) do
    # blocking call => if handle_call callback is not available => this will stop running the code
    # synch request
    GenServer.call(pid, :get_messages)
  end

  def post_message(pid, message) do
    # asynch request
    GenServer.cast(pid, {:post_message, message})
  end

  # server side / callback functions

  def init(messages) do
    {:ok, messages}
  end

  def handle_call(:get_messages, _from, messages) do
    # :reply, old_state, new_state
    {:reply, messages, messages}
  end

  def handle_cast({:post_message, message}, messages) do
    {:noreply, [message | messages]}
  end
end

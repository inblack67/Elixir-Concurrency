defmodule Concurrency.Chat do
  use GenServer

  # client side
  def start_link(_pid) do
    # start a process with the attributes of the current module
    # downside to using :chat_room atom rather than process id is that only one process can be assigned now (:chat_room)
    GenServer.start_link(__MODULE__, [], name: :chat_room)
  end

  def get_messages do
    # blocking call => if handle_call callback is not available => this will stop running the code
    # synch request
    GenServer.call(:chat_room, :get_messages)
  end

  def post_message(message) do
    # asynch request
    GenServer.cast(:chat_room, {:post_message, message})
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

# iex(5)> Process.whereis(:chat_room)
# iex(6)> Process.whereis(:chat_room) |> Process.exit(:kill) # will be restarted again with new process id by the supervisor

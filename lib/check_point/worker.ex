defmodule CheckPoint.Worker do
  use GenServer

  # Client API
  def start_link(default) when is_function(default) do
    GenServer.start_link(__MODULE__, default)
  end

  # Callbacks
  @impl true
  def init(init_arg) do
    {:ok, init_arg}
  end

  @impl true
  def handle_call(_request, from, state) do
    {:reply, from, state}
  end

  @impl true
  def handle_cast(_request, state) do
    {:noreply, state, :hibernate}
  end

  @impl true
  def handle_info(_msg, state) do
    {:noreply, state}
  end
    
  @impl true
  def handle_continue(_continue_arg, state) do
    {:noreply, state}
  end

end

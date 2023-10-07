defmodule CheckPoint.CheckSup do
  @doc """
  DynamicSupervisor to start and supervice CheckPoint.Worker genservers
  """
  use DynamicSupervisor
  alias CheckPoint.Worker

  def start_link(init_arg) do
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def start_child(check, args, opts) do
    spec = {Worker, fn: check, args: args, opts: opts }
    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  @impl true
  def init(init_arg) do
    DynamicSupervisor.init(
      strategy: :one_for_one,
      extra_arguments: [init_arg]
    )
  end
end

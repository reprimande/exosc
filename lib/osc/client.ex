defmodule OSC.Client do
  use GenServer

  def send(ip, port, path, args) do
    data = OSC.Message.construct(path, args)
    GenServer.cast(:osc_client, {:send, ip, port, data})
  end

  # API
  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: :osc_client)
  end

  # Callback
  def init(:ok) do
    :gen_udp.open(0, [:binary, {:active, true}])
  end

  def handle_cast({:send, ip, port, data}, socket) do
    :ok = :gen_udp.send(socket, ip, port, data)
    {:noreply, socket}
  end
end

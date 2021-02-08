defmodule Harald do
  @moduledoc """
  An Elixir Bluetooth Host library.
  """

  alias Harald.HCI.{Commands, Events, SynchronousData, Transport}
  alias Harald.HCI.ACLData

  def hook_strategy_callback(_term) do
    case Application.get_env(:harald, :env) do
      :test -> :runtime
      _target -> {:compile_time, []}
    end
  end

  defdelegate decode_acl_data(bin), to: ACLData, as: :decode

  defdelegate decode_command(bin), to: Commands, as: :decode

  defdelegate decode_event(bin), to: Events, as: :decode

  defdelegate decode_synchronous_data(bin), to: SynchronousData, as: :decode

  defdelegate encode_acl_data(bin), to: ACLData, as: :encode

  defdelegate encode_command(ogf_module, ocf_module), to: Commands, as: :encode

  defdelegate encode_command(ogf_module, ocf_module, parameters), to: Commands, as: :encode

  defdelegate start_link(opts), to: Transport

  defdelegate subscribe(id), to: Transport

  defdelegate subscribe(id, pid), to: Transport

  defdelegate write(id, bin_or_command), to: Transport, as: :write
end

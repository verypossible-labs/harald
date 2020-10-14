defmodule Harald.HCI.Packet do
  @moduledoc """
  Reference: version 5.0, Vol 4, Part A, 2.
  """

  @type type() :: type_command() | type_acl_data() | type_synchronous_data() | type_event()

  @type type_command() :: :command
  @type type_acl_data() :: :acl_data
  @type type_synchronous_data() :: :synchronous_data
  @type type_event() :: :event

  @type indicator() ::
          indicator_command()
          | indicator_acl_data()
          | indicator_synchronous_data()
          | indicator_event()

  @type indicator_command() :: 1
  @type indicator_acl_data() :: 2
  @type indicator_synchronous_data() :: 3
  @type indicator_event() :: 4

  @spec indicator(type()) :: indicator()
  def indicator(:command), do: 1

  def indicator(:acl_data), do: 2

  def indicator(:synchronous_data), do: 3

  def indicator(:event), do: 4
end

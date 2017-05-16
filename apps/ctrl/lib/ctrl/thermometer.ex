defmodule Ctrl.Thermometer do
  @moduledoc false

  @opaque t :: %Ctrl.Thermometer{
    module: module,
    state: term
  }

  @type temp :: float | integer

  defstruct [:module, :state]

  def new(module) do
    {:ok, state} = module.init()
    %Ctrl.Thermometer{module: module, state: state}
  end

  def read(thermometer) do
    apply(thermometer.module, :handle_read, [thermometer.state])
  end

  @callback init() :: {:ok, term}
  @callback handle_read(state :: term) :: temp

end

defmodule Ctrl.Thermometer.Fake do
  @behaviour Ctrl.Thermometer

  def init do
    {:ok, nil}
  end

  def handle_read(nil) do
    time = DateTime.utc_now |> DateTime.to_unix
    :math.sin(time / 20)
  end

end

defmodule Ctrl.Thermometer.Static do
  @behaviour Ctrl.Thermometer

  def init, do: {:ok, nil}

  def handle_read(nil), do: 42

end

defmodule Ctrl.Thermometer.Digital do
  @behaviour Ctrl.Thermometer

  # TODO: Consideration: should I create separate processes (genservers) for the IO bits?

  alias Ctrl.Rpi.W1

  def init, do: {:ok, W1.sensor}

  def handle_read(sensor), do: W1.read sensor

end


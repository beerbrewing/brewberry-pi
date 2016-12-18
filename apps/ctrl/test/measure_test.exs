defmodule MeasureTest do
  @moduledoc false

  use ExUnit.Case

  alias Brewberry.Measure
  alias Brewberry.Sample

  defmodule StaticBackend do
    @behaviour Brewberry.Backend
    def temperature?(), do: 42
    def time?(), do: 12345
  end

  test "temperature can be set" do
        Measure.start_link(StaticBackend)
        %{temperature: temperature, time: time} = Measure.update_sample(%Sample{})

        assert time == 12345
        assert temperature == 42
  end

end

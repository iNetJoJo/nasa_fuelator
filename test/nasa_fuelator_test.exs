defmodule NasaFuelatorTest do
  use ExUnit.Case
  doctest NasaFuelator

  alias NasaFuelator.Enums.GravityConstants

  require GravityConstants

  test "test apollo 11" do
    weight = 28801

    instructions = [
      {:launch, GravityConstants.earth()},
      {:land, GravityConstants.moon()},
      {:launch, GravityConstants.moon()},
      {:land, GravityConstants.earth()}
    ]

    assert NasaFuelator.calculate_fuel(weight, instructions) == {:ok, 51898}
  end

  test "Mission on mars" do
    weight = 14606

    instructions = [
      {:launch, GravityConstants.earth()},
      {:land, GravityConstants.mars()},
      {:launch, GravityConstants.mars()},
      {:land, GravityConstants.earth()}
    ]

    assert NasaFuelator.calculate_fuel(weight, instructions) == {:ok, 33388}
  end

  test "Passenger ship" do
    weight = 75432

    instructions = [
      {:launch, GravityConstants.earth()},
      {:land, GravityConstants.moon()},
      {:launch, GravityConstants.moon()},
      {:land, GravityConstants.mars()},
      {:launch, GravityConstants.mars()},
      {:land, GravityConstants.earth()}
    ]

    assert NasaFuelator.calculate_fuel(weight, instructions) == {:ok, 212_161}
  end

  test "validation test" do
    weight = 75432

    instructions = [
      {:launch, GravityConstants.earth()},
      {:land, GravityConstants.moon()},
      {:launch, GravityConstants.moon()},
      {:land, GravityConstants.mars()},
      {:launch, GravityConstants.mars()},
      {:land, "hehe"}
    ]

    assert NasaFuelator.calculate_fuel(weight, instructions) == {:error, :invalid_instructions}

    instructions = [
      {123, GravityConstants.earth()},
      {:land, GravityConstants.moon()},
      {:launch, GravityConstants.moon()},
      {%{}, GravityConstants.mars()},
      {:launch, GravityConstants.mars()},
      {:land, "hehe"}
    ]

    assert NasaFuelator.calculate_fuel(weight, instructions) == {:error, :invalid_instructions}
  end
end

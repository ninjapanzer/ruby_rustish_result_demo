require_relative './result.rb'

# I have aliased these types just to reduce namespace noise.
Ok = Rustish::Result::Ok
Err = Rustish::Result::Err

# A meme to point out that Gateways are instrumented action containers which return result containers.
class Action
  ## Instrumentaton hook
end

## A Gateway Action, which extends Action and is instrumented for Datadog, but in this configuration acts as a gateway.
# The Gateways can have multiple actions, and each can return an Ok or Err Container.
# Consuming the container can then have various syntactic interfaces, but more importantly, it also supports pattern matching.
class GatewayAction < Action
  include Rustish
  ## Instrumentation refinement for Gateways
end

# An actual gateway
class MyGateway < GatewayAction
  def initialize(item)
    @item = item
  end

  def do
    Ok(@item)
  end

  def do_err
    Err("error")
  end
end

# We can execute a gateway action type and pattern match for succinct error handling.
puts "Exhaustive matching against ok \"it worked\" calling `#do`"
puts case a = MyGateway.new("it worked").do
in Ok
  a.unwrap
in Err
  a.unwrap_err
end

# We can execute a gateway action type and pattern match for succinct error handling.
puts "Exhaustive matching against error \"it worked\" calling `#do_err`"
puts case a = MyGateway.new("it worked").do_err
in Ok
  a.unwrap
in Err
  a.unwrap_err
end

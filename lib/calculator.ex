defmodule Calculator do
  #Start function creates a separate process
  
  def start do
    spawn(fn -> loop(0) end)
  end

  #defp defines a private function
  defp loop(current_value) do

    #Pattern match against the messages that the process receives
    new_value = receive do
      {:value, client_id} -> send(client_id, {:response, current_value})
        #Returns the current value
        current_value

      {:add, valueX, valueY} -> 
        valueX + valueY
        
      {:sub, valueX, valueY} -> 
        valueX - valueY

      {:mult, valueX, valueY} -> 
        valueX * valueY

      {:div, valueX, valueY} -> 
        valueX / valueY

      invalid_request -> IO.puts("Invalid Request #{inspect invalid_request}")
        current_value
    end
    #Tail end recursion
    loop(new_value)
  end


  def value(server_id) do
    #Self means we are going to send the state of the function
    send(server_id, {:value, self()})


    receive do
      #When this function is first called, we will get the current value of our process back
      {:response, value} -> value
    end

    #When the process is first spawned then we'll get zero then perform an operation we'll get the result of that operation
    
  end

  #Sends messages to the created process
  def add(server_id, valueX, valueY) do
     send(server_id, {:add, valueX, valueY})
     value(server_id)
  end

  def sub(server_id, valueX, valueY) do
    send(server_id, {:sub, valueX, valueY})
    #After an operation has been completed return the result by calling 
    value(server_id)
  end

  def mult(server_id, valueX, valueY) do
    send(server_id, {:mult, valueX, valueY})
    value(server_id)
  end

  def div(server_id, valueX, valueY) do
    send(server_id, {:div, valueX, valueY})
    value(server_id)
  end


end

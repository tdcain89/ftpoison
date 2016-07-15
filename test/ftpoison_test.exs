defmodule FTPoisonTest do
  use ExUnit.Case
  doctest FTPoison

  test """
  start/1
  given valid host string
  will start an inets ftp connection
  """ do
    {:ok, pid} = FTPoison.start("localhost")
    refute is_nil(pid)
  end
  
  test """
  start/1
  given invalid host
  will respond with appropriate error
  """ do
    {:error, error_atom} = FTPoison.start("notaserver")
    assert error_atom == :ehost
  end
  
  test """
  start/1
  given valid host
  and inets is already started
  does not fail to start server
  """ do
    :inets.start
    {:ok, pid} = FTPoison.start("localhost")
    refute is_nil(pid)
  end
  
  test """
  pwd/1
  given active FTP PID
  returns current working directory as a String
  """ do
    {:ok, pid} = FTPoison.start("localhost")
    assert_raise FTPoison.Error, " Please login with USER and PASS.\r\n", fn ->
      FTPoison.pwd(pid) == "/"
    end
  end
end

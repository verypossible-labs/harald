{:ok, _} = Hook.Server.start_link([])
ExUnit.start()
:ok = Application.ensure_started(:stream_data)

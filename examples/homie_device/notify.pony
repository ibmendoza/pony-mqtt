use "mqtt"
use "time"

class iso MQTTHomieDeviceNotify is MQTTConnectionNotify
  """
  A notifier for a simple Homie-compliant device.

  More info in: https://github.com/marvinroger/homie
  """
  let _env: Env
  let _id: String
  var _device: (HomieDevice | None) = None

  new iso create(env: Env, id: String) =>
    _env = env
    _id = id

  fun ref on_connect(conn: MQTTConnection ref) =>
    try
        (_device as HomieDevice).restart()
    else
      _device = HomieDevice(_env, conn, _id)
    end

  fun ref on_message(conn: MQTTConnection ref, packet: MQTTPacket) =>
    try (_device as HomieDevice).message(packet) end
    None

  fun ref on_error(conn: MQTTConnection ref, message: String) =>
    _env.out.print("MqttError: " + message)
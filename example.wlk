object puenteBrooklyn {
  method puedeRecibir(mensajero) {
    return mensajero.peso() <= 1000 // hasta una tonelada
  }
}

object laMatrix {
  method puedeRecibir(mensajero) {
    return mensajero.puedeLlamar()
  }
}

object roberto {
  var pesoPropio = 90
  var modo = "camion" // puede ser "bici" o "camion"
  var acoplados = 1

  method peso() {
    if (modo == "bici") {
      return pesoPropio + 5
    } else {
      return pesoPropio + (acoplados * 500)
    }
  }

  method puedeLlamar() {
    return false
  }

  method puedeEntregar(paquete) {
    return paquete.estaPago() && paquete.destino().puedeRecibir(self)
  }
}

object chuckNorris {
  method peso() { return 80 }

  method puedeLlamar() { return true }

  method puedeEntregar(paquete) {
    return paquete.estaPago() && paquete.destino().puedeRecibir(self)
  }
}

object neo {
  var tieneCredito = true

  method peso() { return 0 }

  method puedeLlamar() { return tieneCredito }

  method puedeEntregar(paquete) {
    return paquete.estaPago() && paquete.destino().puedeRecibir(self)
  }
}

object paqueteOriginal {
  var destinoElegido = laMatrix
  var pagado = false

  method destino() { return destinoElegido }

  method estaPago() { return pagado }

  method precio() { return 50 }
}


object paquetito {
  method estaPago() {
    return true // Siempre está pago
  }

  method destino() {
    return puenteBrooklyn // Cualquier destino, no importa
  }

  method puedeSerEntregadoPor(mensajero) {
    return true // Cualquier mensajero puede llevarlo
  }

  method precio() {
    return 0
  }
}

object paquetonViajero {
  var destinos = [puenteBrooklyn, laMatrix]
  var pagado = 0

  method precio() {
    return destinos.size() * 100
  }

  method estaPago() {
    return pagado >= self.precio()
  }

  method pagar(cantidad) {
    pagado = pagado + cantidad
  }

  method puedeSerEntregadoPor(mensajero) {
    // Debe estar pago y el mensajero debe poder pasar por todos los destinos
    return self.estaPago() && destinos.all({ d => d.puedeRecibir(mensajero) })
  }

  method destino() {
    return destinos.first() // Para compatibilidad, aunque no se usa
  }
}

object paquetonViajero {
  var destinos = [puenteBrooklyn, laMatrix]
  var pagado = 0

  method precio() {
    return destinos.size() * 100
  }

  method estaPago() {
    return pagado >= self.precio()
  }

  method pagar(cantidad) {
    pagado = pagado + cantidad
  }

  method puedeSerEntregadoPor(mensajero) {
    // Debe estar pago y el mensajero debe poder pasar por todos los destinos
    return self.estaPago() && destinos.all({ d => d.puedeRecibir(mensajero) })
  }

  method destino() {
    return destinos.first() // Para compatibilidad, aunque no se usa
  }
}

object empresa {
  var mensajeros = []
  var paquetesPendientes = []
  var facturacion = 0

  method contratar(mensajero) {
    mensajeros.add(mensajero)
  }

  method despedir(mensajero) {
    mensajeros.remove(mensajero)
  }

  method despedirATodos() {
    mensajeros.clear()
  }

  method esGrande() {
    return mensajeros.size() > 2
  }

  method puedeEntregarPrimero(paquete) {
    return mensajeros.first().puedeEntregar(paquete)
  }

  method pesoUltimoMensajero() {
    return mensajeros.last().peso()
  }

  method puedeEntregar(paquete) {
    return mensajeros.any({ m => paquete.puedeSerEntregadoPor(m) })
  }

  method mensajerosQuePueden(paquete) {
    return mensajeros.filter({ m => paquete.puedeSerEntregadoPor(m) })
  }

  method tieneSobrepeso() {
    return mensajeros.average({ m => m.peso() }) > 500
  }

  method enviar(paquete) {
    var candidatos = self.mensajerosQuePueden(paquete)
    if (candidatos.isEmpty()) {
      paquetesPendientes.add(paquete)
    } else {
      facturacion = facturacion + paquete.precio()
    }
  }

  method enviarTodos(paquetes) {
    paquetes.forEach({ p => self.enviar(p) })
  }

  method paquetePendienteMasCaro() {
    return paquetesPendientes.max({ p => p.precio() })
  }

  method enviarMasCaroPendiente() {
    var caro = self.paquetePendienteMasCaro()
    if (self.puedeEntregar(caro)) {
      self.enviar(caro)
      paquetesPendientes.remove(caro)
    }
  }
}


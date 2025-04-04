/// Interface que define um contrato para classes que precisam liberar recursos.
/// Deve ser implementada por classes que possuem recursos descartáveis.
abstract class Disposable {
  void dispose();
}

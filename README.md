# iOS Architecture Example Project

Este projeto demonstra boas práticas de **arquitetura, modularização e testes** em aplicações iOS modernas, utilizando Swift 5.9+ e Xcode 15+.  
É ideal para desenvolvedores iniciantes que desejam aprender como estruturar e escalar projetos reais com base em princípios sólidos de engenharia de software.

---

## ✅ Requisitos

- **Swift:** 5.9 ou superior
- **iOS:** 15.0 ou superior
- **Xcode:** 15.0 ou superior

---

## 🧱 Estrutura do Projeto

### 📦 `Packages/`
Contém módulos reutilizáveis e genéricos da aplicação. Atualmente temos o módulo `Service`, mas essa estrutura permite facilmente a criação de outros, como `LocalStorage`, `SQL`, `Analytics`, etc.  
Essa abordagem facilita **separação de responsabilidades** e **escalabilidade**.

### 🔌 `Services/`
Implementa regras gerais de comunicação com APIs. O componente principal é o `ApiService`, que trata requisições, cancela chamadas duplicadas e encapsula erros comuns.

- **ApiServicing**: protocolo que abstrai o serviço de rede. Permite **injeção de dependências** e garante que a feature não dependa da implementação concreta.
- **ApiService**: implementação padrão para requisições. Deve ser injetada, e **não usada diretamente** pelas features.
- **ApiDecoder**: extensão do serviço usando o padrão **Decorator**, responsável por decodificar respostas. Segue o princípio **Open/Closed**, podendo ser reutilizada por qualquer módulo.
- **ApiServicingThreadWrapper / ApiServicingCache**: wrappers que ilustram como aplicar **composição de comportamento** e reforçam a modularidade.
- **ApiStorage**: suporte a cache concorrente e thread-safe. Pode ser reaproveitado em diversos contextos.

### 🎯 Objetivo da Arquitetura

- Separar responsabilidades em **módulos pequenos e independentes**
- Utilizar **injeção de dependência** e **programação orientada a protocolos**
- Demonstrar padrões como **Decorator**, **MVVM**, **Composition** e **SOLID**

---

## 🧪 Testes

Os testes foram escritos com foco em **clareza, previsibilidade e reuso**.

### Estrutura:

- `Mocks` e `Fixtures` definidos junto aos protocolos, com valores padrões simples (vazios, nulos ou fixtures).
- `Doubles`: classe central que organiza mocks/fixtures por teste.
- `makeSut()`: função que configura o sistema sob teste.
- `anyMessages`: estrutura para verificar ordem de chamadas em mocks diferentes.
- Respostas assíncronas são simuladas via arrays de closures (`fetchCompletions`, etc).

### Organização:

- Os testes validam comportamento, e **não implementação**.
- Fixtures garantem **resultados previsíveis**.
- Extensões com `#if DEBUG` garantem que fixtures e mocks não vazem para o build final.

---

DependenciesContainer

O DependenciesContainer é um padrão comum em projetos iOS para centralizar e gerenciar todas as dependências compartilhadas da aplicação. Ele facilita a injeção de dependências, promovendo desacoplamento entre módulos e tornando o código mais testável e modular. No projeto, o DependenciesContainer é instanciado no SceneDelegate e passado para as features (como ListContacts) via injeção de dependências, garantindo que cada componente receba apenas os serviços necessários (por exemplo, ApiService, ImageService, etc).

Esse padrão permite:

- Substituir facilmente implementações reais por mocks em testes, como visto no MockDependenciesContainer.
- Facilitar a manutenção e evolução do projeto, pois novas dependências podem ser adicionadas de forma centralizada.
- Tornar o código mais previsível e seguro, evitando instâncias globais e promovendo o uso de protocolos.

---

## 🔍 Scene: ListContacts

Exemplo de feature implementada com **MVVM**:

- `ViewModel`: controla a lógica da tela e se comunica com a `ViewController` via protocolo (`DisplayLogic`).
- `ViewController`: delega ações ao ViewModel, mantendo a responsabilidade de UI.

Essa separação facilita testes, manutenção e reaproveitamento. A feature poderia facilmente ser extraída para um módulo independente.

---

## 🚀 Recomendações para Devs iOS Iniciantes

- 📦 **Modularize**: separe responsabilidades em pacotes e módulos.
- 🧩 **Use Protocolos**: programe para interfaces, não implementações.
- 🧪 **Teste com Fixtures/Mocks**: torne seus testes previsíveis e reutilizáveis.
- 🧱 **Adote Padrões de Projeto**: como `MVVM`, `Decorator`, `Builder`, etc.
- 🔄 **Planeje a Evolução**: pense em async/await, macros, SwiftData, e mais.

---

## 🔮 Futuras Expansões

- Migrar `ApiService` para `async/await`
- Tornar serviços `Sendable` e `MainActor-safe`
- Extrair `Cache`, `ThreadWrapper` e `Decoder` para módulos separados
- Usar macros para geração de fixtures e helpers de teste

---

## 📚 Referências

- [Apple - Swift Concurrency](https://developer.apple.com/documentation/swift/swift_concurrency)
- [Swift.org - Swift Evolution](https://github.com/apple/swift-evolution)

---

**Este projeto serve como base para aprender e aplicar boas práticas de arquitetura em projetos iOS modernos.**  
Fique à vontade para clonar, estudar, adaptar e contribuir!

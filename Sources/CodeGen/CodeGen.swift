/*
   Copyright 2017 Ryuichi Saito, LLC

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/

import Foundation

import AST
import LLVM

public class CodeGen {
  let _module: Module
  let _builder: IRBuilder

  public init() {
    _module = Module(name: "main")
    _builder = IRBuilder(module: _module)
  }

  public func gen(_ topLevelDecl: TopLevelDeclaration, to file: String) {
    for stmt in topLevelDecl.statements {
      gen(stmt)
    }

    _ = try? _module.print(to: file)
  }

  public func gen(_ stmt: Statement) {
    switch stmt {
    case let funcDecl as FunctionDeclaration:
      gen(funcDecl)
    case let funcCallExpr as FunctionCallExpression:
      gen(funcCallExpr)
    default:
      break
    }
  }

  public func gen(_ funcDecl: FunctionDeclaration) {
    let mainType = FunctionType(argTypes: [], returnType: VoidType())
    let mainFunc = _builder.addFunction(funcDecl.name, type: mainType)

    let entry = mainFunc.appendBasicBlock(named: "entry")
    _builder.positionAtEnd(of: entry)

    let stmts = funcDecl.body?.statements ?? []
    for stmt in stmts {
      gen(stmt)
    }

    _builder.buildRetVoid()
  }

  public func gen(_ funcCallExpr: FunctionCallExpression) {
    guard funcCallExpr.postfixExpression.textDescription == "print" else { return }
    guard let firstArg = funcCallExpr.argumentClause?.first,
      case .expression(let firstExpr) = firstArg,
      let literalExpr = firstExpr as? LiteralExpression,
      case .staticString(let str, _) = literalExpr.kind
    else {
      return
    }

    let formatString = _builder.buildGlobalStringPtr("%s\n")
    let localString = _builder.buildGlobalStringPtr(str)
    _builder.buildCall(printf(), args: [formatString, localString])
  }

  func printf() -> Function {
    if let function = _module.function(named: "printf") {
      return function
    }

    let printfType = FunctionType(
      argTypes: [PointerType(pointee: IntType.int8)],
      returnType: IntType.int32,
      isVarArg: true)
    return _builder.addFunction("printf", type: printfType)
  }
}

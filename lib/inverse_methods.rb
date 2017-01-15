require 'debug_inspector'
require 'byebug'

EvalProc = ->(sym, argument, context){
  eval %{ #{sym}(Marshal.load "#{Marshal.dump argument}") }, context
}

module InverseMethods

  def pass_to(*syms)
    RubyVM::DebugInspector.open { |inspector|
      caller_context = inspector.frame_binding(2)
      syms.each { |sym| EvalProc.call(sym, self, caller_context) }
    }
    self
  end

  def chain_to(*syms)
    RubyVM::DebugInspector.open { |inspector|
      caller_context = inspector.frame_binding(2)
      initial_result = EvalProc.call syms.shift, self, caller_context
      syms.reduce(initial_result) { |result, sym|
        EvalProc.call sym, result, caller_context
      }
    }
  end

  refine Object do
    include InverseMethods
  end

end

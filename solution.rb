class EmptyExpression
  def apply_number(integer)
    SingleNumberExpression.new(integer)
  end
end

NumberCarrier = Struct.new(:number)

class Operation < NumberCarrier
  def operator
    self.class::OPERATOR
  end

  def apply_number(number)
    number.send(operator, self.number)
  end
end

class AdditionExpression < Operation
  OPERATOR = :+
end

class SubtractionExpression < Operation
  OPERATOR = :-
end

class MultiplicationExpression < Operation
  OPERATOR = :*
end

class DivisionExpression < Operation
  OPERATOR = :/
end

class SingleNumberExpression < NumberCarrier
  OPERATIONS = {
    plus:       AdditionExpression,
    minus:      SubtractionExpression,
    times:      MultiplicationExpression,
    divided_by: DivisionExpression
  }

  def method_missing(method_name)
    OPERATIONS[method_name.to_s.sub(/_message/, '').to_sym].new(number)
  end
end

number_mappings = {
  two: 2,
  three: 3,
  four: 4,
  five: 5,
  six: 6,
  seven: 7,
  eight: 8,
  nine: 9
}

number_mappings.each do |name, number|
  define_method(name) do |chain = EmptyExpression.new|
    chain.apply_number(number)
  end
end

SingleNumberExpression::OPERATIONS.each do |operation, _klass_is_disregarded|
  define_method(operation) do |chain|
    chain.send("#{operation}_message")
  end
end

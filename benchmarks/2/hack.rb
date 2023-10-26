# frozen_string_literal: true

require_relative '../base'

module Anyp
  def any?(&block)
    node = RubyVM::AbstractSyntaxTree.of(block)
    body = node.children[2]
    return super unless body.type == :OPCALL
    return super unless body.children[1] == :==

    lhs = body.children[0]
    rhs = body.children[2].children[0]
    if ((col = column_call?(lhs)) && (lit = literal?(rhs))) ||
       ((col = column_call?(rhs)) && (lit = literal?(lhs)))
      exists?(col => lit)
    else
      super
    end
  end

  private def column_call?(node)
    return false unless node.type == :CALL

    recv = node.children[0]
    return false unless recv.type == :DVAR
    return false unless recv.children[0] == :_1

    method = node.children[1]
    return method
  end

  private def literal?(node)
    return false unless node.type == :LIT || node.type == :STR
    node.children[0]
  end
end

ActiveRecord::Base.logger.level = :debug
Article.create!(title: "Hello", content: "World", blog_id: 42)

puts "----- before hacking any? -----"
p Article.all.any? { _1.blog_id == 42 }

puts "----- after hacking any? -----"
ActiveRecord::Relation.prepend(Anyp)
p Article.all.any? { _1.blog_id == 42 }

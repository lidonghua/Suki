utils = require '../src/utils'

describe 'utils', ->
  describe '.di', ->
    it 'should return the arguments list', ->
      func1 = (a, b, c) ->
      utils.di(func1.toString()).should.eql ['a', 'b', 'c']

      func2 = ->
      utils.di(func2.toString()).should.eql []

  describe '.clone', ->
    it 'should clone a object', ->
      obj1 =
        a: 'a'
        b:
          c: 'c'
          d: 'd'
      obj2 = utils.clone obj1
      obj2.should.eql obj1
      obj2.b.c = 'd'
      obj1.b.c.should.eql 'c'

  describe '.splitByCapital', ->
    it 'should split a word by captials', ->
      utils.splitByCapital('showYourName').should.eql ['show', 'your', 'name']
      utils.splitByCapital('show').should.eql ['show']
      utils.splitByCapital('showBooks').should.eql ['show', 'books']

  describe '.capitalize', ->
    it 'should capitalize the word', ->
      utils.capitalize('name').should.eql 'Name'
      utils.capitalize('nameBoy').should.eql 'NameBoy'

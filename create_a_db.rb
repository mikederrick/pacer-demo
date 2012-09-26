require './db_builder'
require 'neo4j'
require 'pacer-neo4j'
require 'fileutils'


puts 'creating the database'
graph = DbBuilder.create_db_from_graphml('./resources/XML/test.graphml')

puts 'Displaying all nodes in the neo4j database'
puts graph.v.properties.inspect


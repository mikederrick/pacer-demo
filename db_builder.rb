require 'neo4j'
require 'pacer-neo4j'
require 'fileutils'
require './lib/blueprints-core-2.1.0.jar'
require './lib/neo4j-1.6.jar'

java_import 'com.tinkerpop.blueprints.util.io.graphml.GraphMLReader'
java_import 'com.tinkerpop.blueprints.impls.neo4j.Neo4jGraph'
java_import 'java.io.FileInputStream'

class DbBuilder
  def self.create_db_from_graphml(graphml_path)
    graph = Neo4jGraph.new('/tmp/pacer_demo')
    reader = GraphMLReader.new(graph)
    reader.inputGraph(FileInputStream.new(graphml_path))
    graph.shutdown

    return Pacer.neo4j('/tmp/pacer_demo')
  end
end
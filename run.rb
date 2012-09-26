require 'pacer-neo4j'
require 'fileutils'

neo4j_file = '/tmp/pacer_demo'
FileUtils.rm_rf(neo4j_file) if Dir.exists?(neo4j_file) # So we can start with a fresh graph every time.s

graph = Pacer.neo4j(neo4j_file)

# For now, building the graph by hand...
# Looks like we can use https://github.com/pangloss/pacer/blob/develop/lib/pacer/graph/graph_ml.rb
# to import GraphML
root = graph.create_vertex
presby = graph.create_vertex

# All of the Time.now.to_i junk is because create_edge requires an edge ID...pretty lame, but it
# looks like there's a TODO to make it optional:
# https://github.com/pangloss/pacer/blob/develop/lib/pacer/graph/pacer_graph.rb#L142
graph.create_edge(Time.now.to_i, root, presby, 'Presby')

emergency_department = graph.create_vertex
graph.create_edge(Time.now.to_i, presby, emergency_department, 'Emergency Department')

chest_pain = graph.create_vertex
graph.create_edge(Time.now.to_i, emergency_department, chest_pain, 'Chest Pain')

ambulance = graph.create_vertex(type: 'Clinicial Decision', question: 'Did the patient arrive by ambulance?')
graph.create_edge(Time.now.to_i, chest_pain, ambulance, 'V1')

# For some reason, boolean properties are stored on the vertex.
# See https://github.com/pangloss/pacer/blob/develop/lib/pacer/graph/pacer_graph.rb#L128 for the raw implementation.
yes_task_group = graph.create_vertex(type: 'Task Group', prioritized: false)
graph.create_edge(Time.now.to_i, ambulance, yes_task_group, 'Yes')
# puts "yes_task_group.properties (notice the missing 'prioritized' property) => #{yes_task_group.properties.inspect}"

# Sample graph traversal wth Pacer:
puts graph.v.out('Presby').out('Emergency Department').out('Chest Pain').out('V1').properties.inspect
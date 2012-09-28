require 'pacer-neo4j'
require 'fileutils'

neo4j_file = '/tmp/pacer_demo'
FileUtils.rm_rf(neo4j_file) if Dir.exists?(neo4j_file) # So we can start with a fresh graph every time.s

graph = Pacer.neo4j(neo4j_file)

root = graph.create_vertex
presby = graph.create_vertex

graph.create_edge(Time.now.to_i, root, presby, 'Presby')

emergency_department = graph.create_vertex
graph.create_edge(Time.now.to_i, presby, emergency_department, 'Emergency Department')

chest_pain = graph.create_vertex
graph.create_edge(Time.now.to_i, emergency_department, chest_pain, 'Chest Pain')

ambulance = graph.create_vertex(type: 'Clinicial Decision', question: 'Did the patient arrive by ambulance?')
graph.create_edge(Time.now.to_i, chest_pain, ambulance, 'V1')

yes_task_group = graph.create_vertex(type: 'Task Group', prioritized: false)
graph.create_edge(Time.now.to_i, ambulance, yes_task_group, 'Yes')

puts graph.v.out('Presby').out('Emergency Department').out('Chest Pain').out('V1').properties.inspect

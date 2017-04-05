require_relative "../src/graph"

graph = Graph.new
graph.load("data")

puts graph.dj_search("washington", "alan")
p graph.bf_search("washington", "alan")
p graph.df_search("washington", "alan")

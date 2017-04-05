require_relative "../src/graph"

graph = Graph.new
graph.load("data")

graph["john"] = Hash.new
graph["john"]["mary"] = 1
graph["john"]["washington"] = 2
graph["john"]["paul"] = 1
graph["john"]["josy"] = 5
graph["john"]["alan"] = 10
graph["john"]["beatriz"] = 20

graph["mary"] = Hash.new
graph["mary"]["john"] = 1
graph["mary"]["alan"] = 1
graph["mary"]["josy"] = 2

graph["washington"] = Hash.new
graph["washington"]["john"] = 2
graph["washington"]["paul"] = 4

graph["paul"] = Hash.new
graph["paul"]["josy"] = 10
graph["paul"]["john"] = 1
graph["paul"]["washington"] = 4

graph["josy"] = Hash.new
graph["josy"]["paul"] = 10
graph["josy"]["alan"] = 2
graph["josy"]["mary"] = 2
graph["josy"]["john"] = 5

graph["alan"] = Hash.new
graph["alan"]["mary"] = 1
graph["alan"]["josy"] = 2
graph["alan"]["john"] = 10

graph["beatriz"] = Hash.new

puts graph.dj_search("washington", "alan")
p graph.bf_search("washington", "alan")
p graph.df_search("washington", "alan")

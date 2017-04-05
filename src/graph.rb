# This class holds all the graph nodes and their neighbours
# into a hash and defines search functions that can
# be used to search the graph.
#
# Every node is an entry into the hash, its value should be a
# new hash containing all the neighbouring nodes and their 
# distances.

class Graph < Hash
    
    # Runs a depth-first search on the graph to find
    # a path from +start+ to +goal+.
    # Params:
    # +start+:: the key of the start node
    # +goal+:: the key of the end node
    # Returns:
    # * an +Array+ containing a path from start to goal
    # * nil if no path is found
    def df_search(start, goal)
        search(start, goal) {|fringe| fringe.pop}
    end

    # Runs a breadth-first search on the graph to find
    # the path with the least amount of nodes from
    # +start+ to +goal+.
    # Params:
    # +start+:: key of start node
    # +goal+:: key of end node
    # Returns:
    # * an +Array+ containing the shortest path from start to goal
    # * +nil+ if no path is found
    def bf_search(start, goal)
        search(start, goal) {|fringe| fringe.delete_at(0)}
    end

    # Runs a search using the Dijkstra's algorithm to find
    # the lowest cost path from +start+ to +goal+.
    # Params:
    # +start+:: key of start node
    # +goal+:: key of end node
    # Returns:
    # * a +Hash+ containing a list representing the cheapest path (:path) and the total cost (:cost)
    # * +nil+ if no path is found
    def dj_search(start, goal)
        costs = Hash.new(Float::INFINITY)
        checked = Hash.new(false)
        parents = Hash.new(nil)

        costs[start] = 0
        curr = start

        while curr != nil do
            checked[curr] = true

            if curr == goal
                return Hash[:path => reconstruct_path(start, goal, parents), :cost => costs[curr]]
            end

            self[curr].each {|key, cost| 
                new_cost = costs[curr] + cost

                if new_cost < costs[key]
                    costs[key] = new_cost
                    parents[key] = curr
                end
            }

            curr = costs.select{|k, v| !checked[k]}.min_by{|k, v| v}[0]
        end
        nil
    end

    # Generic search method that serves as a foundation for
    # both #bf_search and #df_search.
    # Params:
    # +start+:: key of start node
    # +goal+:: key of end node
    # Returns:
    # * an +Array+ containing a path from +start+ to +goal+
    # * +nil+ if no path is found
    def search(start, goal)
        checked = Hash.new(false)
        parents = Hash.new(nil)
        fringe = [start]

        checked[start] = true

        while !fringe.empty? do
            curr = yield fringe
            return reconstruct_path(start, goal, parents) if curr == goal

            self[curr].each_key {|key|
                next if checked[key]
                fringe.push(key)
                checked[key] = true
                parents[key] = curr
            }
        end
        nil
    end

    # Recursive method that reconstructs the path from start to goal.
    # Params:
    # +start+:: key of start node
    # +goal+:: key of end node
    # +parents+:: a +Hash+ that maps from a node to its parent
    # Returns:
    # * an +Array+ containing the reconstructed path from +start+ to +goal+
    def reconstruct_path(start, goal, parents)
        start == goal ? [goal] : reconstruct_path(start, parents[goal], parents) + [goal]
    end

    # Loads a graph stored in a file. Every line of the file should
    # define a node name and its neighbours. Every neighbour should
    # be defined at some point in the file. Example:  
    # <tt>mary john(2) phil(4) alex(12)</tt>  
    # <tt>john mary(2)</tt>  
    # <tt>alex phil(5) mary(1)</tt>  
    # <tt>phil</tt>  
    #   
    # Params:
    # +filename+:: filename of the data file
    def load(filename)
        data = File.open(filename, "r")
        
        while line = data.gets
            tokens = line.chomp.split
            definition = tokens.delete_at(0)
            self[definition] = Hash.new

            tokens.each {|t| 
                t = t.gsub(/[()]/, " ").split
                self[definition][t[0]] = t[1].to_i
            }
        end

        data.close
    end
end

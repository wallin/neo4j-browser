// Get all nodes
MATCH (n{{':'+selected_label}}) 
RETURN n LIMIT 1000
// Count nodes
MATCH (n{{':'+selected_label}}) 
RETURN count(n)
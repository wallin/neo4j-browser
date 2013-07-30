// Find a node
MATCH (n{{':'+selected_label}}) 
WHERE n.{{indexed_property}} = "{expected_value}" RETURN n
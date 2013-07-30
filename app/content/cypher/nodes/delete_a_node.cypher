// Delete a node
START n=node(*) MATCH (n{{':'+selected_label}})-[r?]-() 
WHERE {{indexed_property}} = "{expected_value}"
DELETE n,r
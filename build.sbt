name := "LocalGraph"

version := "1.0"

scalaVersion := "2.10.2"

scalaSource in Compile <<= baseDirectory(_ / "tools" / "src")

target <<= baseDirectory { _ / "tools" / "target" }

mainClass in (Compile, run) := Some("org.neo4j.tools.localgraph.LocalGraph")

libraryDependencies ++= Seq(
    "org.neo4j" % "neo4j-community" % "2.0.0-M03",
    "org.neo4j.app" % "neo4j-server" % "2.0.0-M03",
    "org.neo4j.app" % "neo4j-server" % "2.0.0-M03" classifier "static-web",
    "com.sun.jersey" % "jersey-core" % "1.14",
    "com.sun.jersey" % "jersey-server" % "1.14",
    "com.sun.jersey" % "jersey-servlet" % "1.14"
  )


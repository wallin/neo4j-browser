import AssemblyKeys._

name := "GraphBridge"

version := "1.0"

scalaVersion := "2.10.2"

scalaSource in Compile <<= baseDirectory(_ / "tools" / "src")

resourceDirectory in Compile <<= baseDirectory(_ / "dist")

target <<= baseDirectory { _ / "tools" / "target" }

mainClass in (Compile, run) := Some("org.neo4j.tools.localgraph.LocalGraph")

libraryDependencies ++= Seq(
    "org.neo4j" % "neo4j-community" % "2.0.0-M03" % "provided",
    "org.neo4j.app" % "neo4j-server" % "2.0.0-M03" % "provided",
    "org.neo4j.app" % "neo4j-server" % "2.0.0-M03" % "provided" classifier "static-web",
    "com.sun.jersey" % "jersey-core" % "1.14" % "provided",
    "com.sun.jersey" % "jersey-server" % "1.14" % "provided",
    "com.sun.jersey" % "jersey-servlet" % "1.14" % "provided"
  )

// custom assembly for web-app, but not the java/scala stuff

assemblySettings

jarName in assembly := "neo4j-webui.jar"

test in assembly := {}

assembleArtifact in packageScala := false

// exclude class files
mergeStrategy in assembly <<= (mergeStrategy in assembly) { (old) =>
  {
    case PathList("org", xs @ _*) => MergeStrategy.discard
    case x => old(x)
  }
}

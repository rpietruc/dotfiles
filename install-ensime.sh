#!/bin/bash

mkdir -p ~/.sbt/1.0/plugins/
echo 'addSbtPlugin("org.ensime" % "sbt-ensime" % "2.5.1")' >> ~/.sbt/1.0/plugins/plugins.sbt
yaourt -S openjdk-src
echo "for each Scala project run: sbt ensimeConfig"

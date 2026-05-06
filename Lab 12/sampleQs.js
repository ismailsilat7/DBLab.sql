// Fresh DB

```
use UniversityDB
```

db.createCollection("Students")

db.Students.insertMany([
  { _id: 1, name: "Ali", age: 21, city: "Karachi", department: "CS", grades: { math: 88, science: 75 } },
  { _id: 2, name: "Sara", age: 22, city: "Lahore", department: "EE", grades: { math: 90, science: 85 } },
  { _id: 3, name: "Usman", age: 20, city: "Karachi", department: "CS", grades: { math: 60, science: 70 } },
  { _id: 4, name: "Ayesha", age: 23, city: "Islamabad", department: "BBA", grades: { math: 95, science: 92 } },
  { _id: 5, name: "Bilal", age: 21, city: "Karachi", department: "CS", grades: { math: 55, science: 80 } }
])

db.Students.find()

"The university wants a list of all CS students from Karachi, but only wants to see their names and grades — not their city, department, or ID."

db.Students.find(
  { department: "CS", city: "Karachi" },
  { name: 1, grades: 1, _id: 0 }
)

"The university wants to find all students who scored less than 80 in math OR are older than 22. Display only their names, ages and math scores."

db.Students.find(
  { $or: [ { "grades.math": { $lt: 80 } }, { age: { $gt: 22 } } ] },
  { name: 1, age: 1, "grades.math": 1, _id: 0 }
)

"A professor wants to give bonus marks. Increase the science score by 10 for all CS students whose math score is less than 70."

db.Students.updateMany(
  { "grades.math": { $lt: 70 }, department: "CS" },
  { $inc: { "grades.science": 10 } }
)

"The university is cleaning up records. Delete the student whose name is 'Bilal' and is from the CS department. But first, display his record before deleting him."

db.Students.findOneAndDelete(
  {name: "Bilal", department: "CS"}
)

"The university wants a report showing how many students are in each department, sorted by the count in descending order."

db.Students.aggregate([
  { $group: { _id: "$department", total: { $sum: 1 } } },
  { $sort: { total: -1 } }
])

"The university wants to see the top 2 students with the highest math scores. Display only their names and math scores, no ID."

db.Students.find(
  {},
  { name: 1, "grades.math": 1, _id: 0 }
).sort({ "grades.math": -1 }).limit(2)

"The university admin is searching for students but only remembers that the student's name starts with the letter 'A'. Find all such students and display their names and cities only."

db.Students.find(
  {name: {$regex: '^A', $options: "i"}}, {name: 1, city: 1, _id: 0}
)

"The university wants to find all students who are either from Lahore, or have scored greater than or equal to 85 in both math AND science. Display their names, cities and grades only."

db.Students.find(
  { $or: [
      { city: "Lahore" },
      { $and: [
          { "grades.math": { $gte: 85 } },
          { "grades.science": { $gte: 85 } }
      ]}
  ]},
  { name: 1, city: 1, grades: 1, _id: 0 }
)

"The university wants a report showing the average math score per city, but only for cities where the average math score is greater than 75. Sort the results by average score in descending order."

db.Students.aggregate([
  { $group: { _id: "$city", average_math_score: { $avg: "$grades.math" } } },
  { $match: { average_math_score: { $gt: 75 } } },
  { $sort: { average_math_score: -1 } }
])



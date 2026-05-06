
// use SchoolDB
```
1. Create a database named SchoolDB.
2. Create two collections:
    o Students
    o Courses
3. Insert the following documents into the Students collection:
4. Insert the following documents into the Courses collection:
```
db.createCollection("students")
db.createCollection("courses")
db.students.insertMany([
  {_id: 1, name: "Alice", age: 20, scores: {math: 85, science: 90}},
  {_id: 2, name: "Bob", age: 22, scores: {math: 78, science: 82}},
  {_id: 3, name: "Charlie", age: 21, scores: {math: 92, science: 88}},
  {_id: 4, name: "Daisy", age: 23, scores: {math: 68, science: 74}}
])
db.courses.insertMany([
  {_id: 101, courseName: "Mathematics", instructor: "Dr. Smith", studentsEnrolled: [1, 2, 3]},
  {_id: 102, courseName: "Science", instructor: "Dr. Adams", "studentsEnrolled": [2,3,4]}
])

// Q5
```
5. Use findOne to retrieve:
    o A student where the math score is >= 85 and the age is < 22.
    o A course where the studentsEnrolled array includes 3 and the instructor is "Dr. Adams".
```
db.students.findOne(
  {"scores.math": {$gte: 85}, age: {$lt: 22}}
)

db.courses.findOne(
  {instructor: "Dr. Adams", studentsEnrolled: 3}
)

// Q6
```
6. Use find to retrieve:
    o Students with math score >= 80 and science score < 90.
    o Students whose age is < 23 or have a math score >= 85.
    o Students with science score >= 80 and (either math score < 75 or age > 22).
```
db.students.find(
  {"scores.math": {$gte: 80}, "scores.science": {$lt: 90}}
)

db.students.find(
  {$or: [{age: {$lt: 23}}, {"scores.science": {$gte: 85}}]}
)

db.students.find(
  {"scores.science": {$gte : 80}, $or : [
    {"scores.math": {$lt: 75}},
    {age: {$gt: 22}}
  ]}
)

// Q7
```
7. Use updateOne to:
    o Increase the science score of the student where name is "Bob" and math score is >= 75.
```
db.students.updateOne(
  {name: "Bob", "scores.math": {$gte: 75}},
  {$inc: {"scores.math": 5}}
)

// Q8
```
8. Use updateMany to:
    o Increase the math score by 5 for students whose science score is < 80 and age > 22.
```
db.students.updateMany(
  {"scores.science": {$lt: 80}, age: {$gt: 22}},
  {$inc: {"scores.math": 5}}
)

// Q9
```
9. Use deleteOne to:
    o Remove a student where name is "Daisy" and their science score is < 80.
```
db.students.deleteOne(
  {name: "Daisy", "scores.science": {$lt: 80}}
)

// Q10
```
10. Use deleteMany to:
    o Remove courses where the studentsEnrolled array includes 2 or the instructor is "Dr. Smith".
```
db.courses.deleteMany(
  {$or: [
    {studentsEnrolled: 2},
    {instructor: "Dr. Smith"}
  ]}
)

// Q11-13
```
11. Drop the Students collection.
12. Drop the Courses collection.
13. Finally, delete the SchoolDB database.
```
db.students.drop()
db.courses.drop()
db.dropDatabase()


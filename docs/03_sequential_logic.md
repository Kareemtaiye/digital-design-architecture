## The big shift

Unlike before, electricity pass through gates, propagation delay happened, and the output is updated immediately.
When the inputs are turned off, the outputs become lost too(instantly).

In the world of sequential logic HDL, the circuits remember their old value, i.e, they have memory, even when their inputs are turned off.
The retain their value until they are explicity told to change them.
So unlike combinational logic reacts instantly whenever any input on the right side changes, the sequential logic reacts only when a specific even happens(like a clock edge).

Seq. blocks uses the **always** statement to handle the sensitivity list.

The always statement is written in the form:

```
     always @(sensitivity list)
          statement;
```

The statement is executed only when the specified events in the sensitivity list occurs.

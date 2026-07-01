## The big shift

## 1. Sensitivity list

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

## 2. The parallel nature of hardware

Unlike the software blocking assignment(**=**), where code executes strictly line-by-line, that is not how a circuot work.
Non blocking assignment(_<=_) is design to model, parallel physicla hardware, where everything happens at the exact same time.
All right-hand sides are evaluated simultaneously and their values are assigned to the left-hand sides only after the block finishes.

```
     always_ff @(posedge clk)
        begin
            n1 <= d;
            q <= n1;
        end
```

q takes the old value of n1. It will recieve the new value of n1 on the second clock edge(After it has resolved to a stable value).

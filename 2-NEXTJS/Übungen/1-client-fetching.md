## Fragen

### Frage 1

**Was ist das Problem mit folgendem Data-Fetching-Code?**

```ts
useEffect(() => {
  fetch("/api/data")
    .then((res) => res.json())
    .then((data) => setData(data));
}, []);
```


---

### Frage 2

**Warum wird empfohlen, Server Functions nicht für Data Fetching in Next.js zu verwenden?**

---

### Frage 3

**Was ist die Ausgabe der folgenden Zod-Validierung?**

```ts
const userSchema = z.object({
  name: z.string(),
  age: z.number().min(18),
});

const result = userSchema.safeParse({
  name: "Alice",
  age: 16,
});

console.log(result.success);
```

---

### Frage 4

**Was macht folgende Mutation beim Absenden des Formulars?**

```ts
const mutation = useMutation({
  mutationFn: (newUser) =>
    fetch("/api/users", {
      method: "POST",
      body: JSON.stringify(newUser),
    }),
  onSuccess: () => {
    console.log("User created!");
  },
});

<form
  onSubmit={(e) => {
    e.preventDefault(); // ???
    mutation.mutate({ name: "Jane" }); // ???
  }}
>
  <button type="submit">Create User</button>
</form>;
```

---

### Frage 5

**Was macht die Option `staleTime` im folgenden Code?**

```ts
useQuery(["todos"], fetchTodos, { staleTime: 10000 });
```


Populate Me
===========

Overview
--------

Documents
---------

The `field` method allows you to record anything about
itself, but here are the keys used by `PopulateMe`:

- `:type` Defines the type of field (please find the list of types below).
- `:form_field` Set to `false` if you do not want this field in the default form.
- `:label` What the label in the form says (defaults to a human-friendly version of the field name)
- `:wrap` Set it to false if you do not want the form field to be wrapped in a `div` with a label.

Available types are:

- `:string` Short text.
- `:text` Multiline text.
- `:boolean` Which is `true` or `false`.
- `:list` List of embeded documents.
- `:select` Dropdown list of options (records a string).

Admin
-----

API
---


{% macro compute_conversion(column1, column2) %}
    {{ column1 }}::float / {{ column2 }}::float
{% endmacro %}
{% macro generate_md5_comparision(columns, src='s', tgt='t') %}
    md5(
        concat(
            {% for c in columns %}
                coalesce(
                    cast({{ src }}.{{ c }} as string), ''
                )
            {% if not loop.last %}, {% endif %}
            {% endfor %}
        )
    ) != md5(
        concat(
            {% for c in columns %}
                coalesce(
                    cast({{ tgt }}.{{ c }} as string), ''
                )
            {% if not loop.last %}, {% endif %}
            {% endfor %}
        )
    )

{% endmacro %}
package com.example.backend.enums;

public enum TodoStatusEnum {
    CHUA_HOAN_THANH(1L),
    DA_HOAN_THANH(2L),
    DANG_DIEN_RA(3L);

    private final Long id;

    TodoStatusEnum(Long id) {
        this.id = id;
    }

    public Long getId() {
        return id;
    }
}

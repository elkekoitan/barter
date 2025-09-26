# Provide Missing Data Sources

**Summary**: DI imports user/listing/barter remote data sources that are not present.
**Impact**: Import errors prevent builds.
**Recommended Steps**:
- Create the missing remote data source files (and matching interfaces/impls).
- Or remove the imports until the modules are delivered.
- Update DI tests once the files exist.
